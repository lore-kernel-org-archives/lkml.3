Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaCZKur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:50:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:58724 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:50:45 -0400
Message-ID: <5332B102.9040709@linutronix.de>
Date: Wed, 26 Mar 2014 11:50:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, balbi@ti.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "3.9+" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: zero: Fix SuperSpeed enumeration for alternate
 setting 1
References: <1395826086-5097-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1395826086-5097-1-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 10:28 AM, Roger Quadros wrote:
> Bug was introduced by commit cf9a08ae in v3.9

I'm sorry for the trouble.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
