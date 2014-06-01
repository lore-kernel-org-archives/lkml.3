Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaFAAEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:04:33 -0400
Received: from donald.hachti.de ([188.40.85.216]:37160 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaFAAEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:04:32 -0400
Message-ID: <538A6E0D.2040208@hachti.de>
Date: Sun, 01 Jun 2014 02:04:29 +0200
From: Philipp Hachtmann <hachti@hachti.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
References: <1401579066-8298-1-git-send-email-hachti@hachti.de> <1401579066-8298-3-git-send-email-hachti@hachti.de>
In-Reply-To: <1401579066-8298-3-git-send-email-hachti@hachti.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.06.2014 01:31, Philipp Hachtmann wrote:
> This patch adds a sysfs attribute "cbus" which allows to set the four CBUS
> pins on the FT232H.
The patch contains a *small* error that happened when splitting up my 
modifications. Next series will contain the clean variant.



