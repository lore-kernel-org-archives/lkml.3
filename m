Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaHKFkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:40:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaHKFke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:40:34 -0400
Date: Mon, 11 Aug 2014 13:39:59 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] staging: et131x: Fix errors caused by
 phydev->addr accesses before initialisation
Message-ID: <20140811053959.GD13727@kroah.com>
References: <1407705415-14886-1-git-send-email-mark.einon@gmail.com>
 <CAJL_dMub6FN+HvueQ4ZJCT2TPi9-86x8VF2hG00K8CDm5bR7rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJL_dMub6FN+HvueQ4ZJCT2TPi9-86x8VF2hG00K8CDm5bR7rw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:32:55AM +0300, Anca Emanuel wrote:
> Do you have this hardware ? And did you test this ?

Mark is the maintainer of this driver, I assume he has the hardware, if
not, I don't care, I trust him :)

> How can you cc stable without an Tested by somebody else ?

Since when is a tested-by a requirement for a stable@ marking?  Please
read Documentation/stable_kernel_rules.txt for the details.

thanks,

greg k-h
