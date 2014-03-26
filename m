Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaCZRES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:04:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50594 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaCZREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:04:16 -0400
Date: Wed, 26 Mar 2014 17:04:04 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] input: misc: Add driver for Intel Bay Trail GPIO
 buttons
Message-ID: <20140326170404.47a6380a@alan.etchedpixels.co.uk>
In-Reply-To: <53325F30.4030006@linux.intel.com>
References: <533259F7.3050908@linux.intel.com>
	<53325F30.4030006@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 13:01:36 +0800
"Zhu, Lejun" <lejun.zhu@linux.intel.com> wrote:

> This patch adds support for the GPIO buttons on some Intel Bay Trail
> tablets originally running Windows 8. The ACPI description of these
> buttons follows "Windows ACPI Design Guide for SoC Platforms".

I'm not sure calling it "Baytrail" is right here - it's in theory a
generic interface so probably should be named accordingly

Otherwise looks good to me.

Alan
