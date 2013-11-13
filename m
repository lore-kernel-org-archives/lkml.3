Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab3KMWxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:53:21 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:55130 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KMWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:53:15 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 17:53:15 EST
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>, Evgeny Boger <eugenyboger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
In-Reply-To: <20131113040707.GK5509@spacedout.fries.net>
References: <1384180614-9025-1-git-send-email-boger@contactless.ru>
 <10261384211376@web11j.yandex.ru>
 <5281691F.4060604@gmail.com>
 <37621384218204@web11j.yandex.ru>
 <52817F42.2080706@gmail.com>
 <20131112080146.GF5509@spacedout.fries.net>
 <5282D2C8.6030002@gmail.com> <20131113040707.GK5509@spacedout.fries.net>
Subject: Re: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
MIME-Version: 1.0
Message-Id: <289151384382560@web28g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 14 Nov 2013 02:42:40 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

13.11.2013, 08:07, "David Fries" <david@fries.net>:
>>>> ššStrong pullup is emulated by driving pin logic high after write
>>>> ššcommand when
>>>> ššusing tri-state push-pull GPIO.
>
> Acked-by: David Fries <david@fries.net>
>
> Looks good to me.

Ok, thank you

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Evgeny, can you please resend the whole patch to Greg <greg@kroah.com>,
he will pick it up and push into upstream
