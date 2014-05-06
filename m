Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaEFTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:11:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaEFTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:11:09 -0400
Date: Tue, 6 May 2014 20:11:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IMA & truncate
Message-ID: <20140506191105.GV18016@ZenIV.linux.org.uk>
References: <5368E46B.9050708@samsung.com>
 <20140506165901.GS18016@ZenIV.linux.org.uk>
 <1399401557.9468.21.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399401557.9468.21.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:39:17PM -0400, Mimi Zohar wrote:

> Al, you're not going to like this, but ima_calc_file_hash() calls
> ima_calc_file_hash_tfm(), which already sets/unsets FMODE_READ in order
> to calculate the file hash.

And if it happens to be on NFS and server says "no reads for you"?
