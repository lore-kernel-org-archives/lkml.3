Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaGWM3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:29:15 -0400
Received: from cpc2-cwma8-2-0-cust224.7-3.cable.virginm.net ([82.20.154.225]:57266
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755434AbaGWM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:29:14 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 08:29:12 EDT
Date: Wed, 23 Jul 2014 13:18:38 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: Fix me in dasd_eer.c
Message-ID: <20140723131838.36359512@alan.etchedpixels.co.uk>
In-Reply-To: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
References: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 02:29:32 -0400
Nicholas Krause <xerofoify@gmail.com> wrote:

> This patch changes return type to EMEDUIMTYPE in function, dasd_eer_enable
> for when checking if the medium has no errors according to this function.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

What distributions have you tested this with and what configurations?
