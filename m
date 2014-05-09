Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaEIH2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:28:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39720 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaEIH2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:28:42 -0400
Date: Fri, 9 May 2014 10:28:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about
 git
Message-ID: <20140509072801.GI26890@mwanda>
References: <536A5A1E.6070004@codeaurora.org>
 <20140508084412.GA20398@mwanda>
 <20140508090508.GA16423@jak-x230>
 <CAJd=RBBNbJnTsu=73o9Yy4dgVw2zUJR9Cc5=eZB+U+WqJ=4KDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBNbJnTsu=73o9Yy4dgVw2zUJR9Cc5=eZB+U+WqJ=4KDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 05:28:46PM +0800, Hillf Danton wrote:
> And a howto to tame gmail is doule apprecaited.

There is actually a gmail section in the man page.  `man git send-email`
It's a the bottom.


EXAMPLE
   Use gmail as the smtp server
       To use git send-email to send your patches through the GMail SMTP
       server, edit ~/.gitconfig to specify your account settings:

           [sendemail]
                   smtpencryption = tls
                   smtpserver = smtp.gmail.com
                   smtpuser = yourname@gmail.com
                   smtpserverport = 587

       Once your commits are ready to be sent to the mailing list, run the
       following commands:

           $ git format-patch --cover-letter -M origin/master -o outgoing/
           $ edit outgoing/0000-*
           $ git send-email outgoing/*

       Note: the following perl modules are required Net::SMTP::SSL,
       MIME::Base64 and Authen::SASL


regards,
dan carpenter
