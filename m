Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3KNSyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:54:25 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44423 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3KNSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <1384440661-3769-1-git-send-email-lpapp@kde.org>
References: <1384440661-3769-1-git-send-email-lpapp@kde.org>
Date: Thu, 14 Nov 2013 18:54:17 +0000
X-Google-Sender-Auth: lgzcYkeb5QTGrZOsIDu-G2-nvaE
Message-ID: <CAOMwXhMS-0AUHQ5tOo9oYEWzRZOo_DnVhm9-tYcjhhyThtca-g@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (max6650) Add support for gpiodef
From: Laszlo Papp <lpapp@kde.org>
To: hjk@hansjkoch.de
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 2:51 PM, Laszlo Papp <lpapp@kde.org> wrote:
> +       case 1:
> +               data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO1_LOW;
> +               data->gpiodef &= (gpio << 2);

Yikes, that should have been "|=" of course. I will fix it if needed
once the right approach is found and agreed upon...
