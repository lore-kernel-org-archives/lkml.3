Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbaFJG6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:58:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36385 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaFJG6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:58:18 -0400
Date: Tue, 10 Jun 2014 09:57:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        navin patidar <navinp@cdac.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_main.c: Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140610065735.GF5500@mwanda>
References: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 11:39:49PM +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> This was partly found using a static code analysis program called cppcheck.
> 

We already knew that the string was NUL terminated because we checked
strnlen() on the lines before.

regards,
dan carpenter

