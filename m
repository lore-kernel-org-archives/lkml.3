Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3DKHKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:10:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:22064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab3DKHKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,453,1363158000"; 
   d="scan'208";a="284662397"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>,
        linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: Re: [PATCH] drivers: usb: chipidea: convert to devm_ioremap_resource()
In-Reply-To: <1365627935-17561-1-git-send-email-silviupopescu1990@gmail.com>
References: <1365627935-17561-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Apr 2013 10:12:56 +0300
Message-ID: <87r4ih5ymf.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silviu-Mihai Popescu <silviupopescu1990@gmail.com> writes:

> Convert  use of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.

You mean, you've run coccinelle? Remember to mention it, then.

> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

That's cool, but your chipidea patches have to be based off of
ci-for-greg branch of the chipidea tree [1] or at least usb-next branch
of Greg's usb.git [2].

[1] git://github.com/virtuoso/linux-ci.git
[2] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git

Regards,
--
Alex
