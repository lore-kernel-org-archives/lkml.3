Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaJ1O1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:27:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48610 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaJ1O07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:26:59 -0400
Message-ID: <1414506184.6815.111.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 0/3] integrity: NULL pointer dereference fixes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, jmorris@namei.org, dmitry.kasatkin@gmail.com
Date: Tue, 28 Oct 2014 10:23:04 -0400
In-Reply-To: <cover.1414494901.git.d.kasatkin@samsung.com>
References: <cover.1414494901.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102814-0033-0000-0000-0000027D95F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 13:31 +0200, Dmitry Kasatkin wrote: 
> Hi,
> 
> Recently Jan Kara reported about possible NULL pointer dereference
> in IMA and EVM setxattr hooks. This patchset fixes the problem.
> 
> http://sourceforge.net/p/linux-ima/mailman/message/32957578
> 
> In this version of the patchset we agreed with Mimi to split IMA
> patch into two, where the first patch fixes the oops and must go to
> the stable and the second patch limits setting of file hash to fix
> and log modes and may go to the next kernel version via normal process.

Thanks, Dmitry.  James, I'll send you a pull request shortly for Linus,
deferring one patch until the 3.19 open window.

For-Linus: 
[PATCH v3 1/3] ima: check xattr value length and type in the ima_inode_setxattr()
                                  [P
ATCH v3 1/1] evm: check xattr value
length and type in
evm_inode_setxattr()

3.19: [v3 2/3] ima: limit file hash setting by user to fix and log modes

Mimi

