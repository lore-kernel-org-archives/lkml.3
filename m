Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3K2MQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:16:34 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34353 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K2MQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:16:32 -0500
MIME-Version: 1.0
In-Reply-To: <1595199.2xkkMsZdTD@vostro.rjw.lan>
References: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
	<1595199.2xkkMsZdTD@vostro.rjw.lan>
Date: Fri, 29 Nov 2013 13:16:31 +0100
Message-ID: <CACRpkdZJTpUDO6ZxrUS+02docY8wDyz0eZP3AM3qA_WwoaKAbw@mail.gmail.com>
Subject: Re: [PATCH] acpi: Add BayTrail SoC GPIO and LPSS ACPI IDs
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Paul Drews <paul.drews@intel.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 2:29 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, November 25, 2013 02:15:55 PM Paul Drews wrote:
>> This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
>> banks as seen on a BayTrail M System-On-Chip platform.  This
>> ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
>> manage the Low Power Subsystem (LPSS).
>>
>> Signed-off-by: Paul Drews <paul.drews@intel.com>
>
> Linus, any objections to this?  If not, I'll take it for 3.14.

Go ahead,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
