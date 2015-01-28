Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbbA1WWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:22:39 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:56293
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbbA1ULu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:50 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/6] staging: comedi: reformat comedi_fops and range
 comments
Thread-Topic: [PATCH 0/6] staging: comedi: reformat comedi_fops and range
 comments
Thread-Index: AQHQOyocb18Nv5gULk+0PgKxKgyfl5zV9h8w
Date: Wed, 28 Jan 2015 20:11:43 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260F706B@P3PWEX4MB008.ex4.secureserver.net>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 28, 2015 11:42 AM, Ian Abbott wrote:
> 1) staging: comedi: comedi_fops.c: reformat copyright header
> 2) staging: comedi: comedi_fops.c: document exported functions
> 3) staging: comedi: comedi_fops.c: reformat ioctl handler comments
> 4) staging: comedi: range.c: reformat ioctl handler comment
> 5) staging: comedi: range.c: reformat copyright comment
> 6) staging: comedi: comedi_fops.c: reformat remaining block comments
>
>  drivers/staging/comedi/comedi_fops.c | 437 +++++++++++++++++++----------------
>  drivers/staging/comedi/range.c       |  56 ++---
>  2 files changed, 272 insertions(+), 221 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

