Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3A3KqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:46:14 -0500
Received: from smtp4.nedap.com ([213.160.213.85]:56813 "EHLO smtp.nedap.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754525Ab3A3KqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:46:12 -0500
From: Dirkjan Bussink <dirkjan.bussink@nedap.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jan 2013 11:46:12 +0100
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
Thread-Topic: [PATCH] tty: Prevent deadlock in n_gsm driver
Thread-Index: Ac3+1wQ9/PulYGjFRjS2YhOFyVRo4A==
Message-ID: <1B6779BD-8FFA-43A2-A9DE-C27CCCB58B33@nedap.com>
References: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
 <20130130051213.GA26675@kroah.com>
 <0E76C0E9-AC46-42C0-BF43-12DAF0DCE313@nedap.com>
 <20130130101058.GA9532@kroah.com>
In-Reply-To: <20130130101058.GA9532@kroah.com>
Accept-Language: en-US, nl-NL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, nl-NL
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30 Jan 2013, at 11:10, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This patch breaks the build in the tty-next tree:
> 
> drivers/tty/n_gsm.c: In function ‘gsm_dlci_release’:
> drivers/tty/n_gsm.c:1713:3: error: too few arguments to function ‘tty_unlock’
> In file included from drivers/tty/n_gsm.c:44:0:
> include/linux/tty.h:596:24: note: declared here
> drivers/tty/n_gsm.c:1715:3: error: too few arguments to function ‘tty_lock’
> In file included from drivers/tty/n_gsm.c:44:0:
> include/linux/tty.h:595:24: note: declared here
> 
> Can you fix this up (get it to build on the linux-next tree) and resend
> it?

I've resent it with the proper changes. I also tried to ensure that the patch
wasn't mangled this time, so that should be good as well now. Please let me
know if this is still problematic, I've used mutt and -H to send the patch
created with git format-patch. 

-- 
Regards,

Dirkjan Bussink

