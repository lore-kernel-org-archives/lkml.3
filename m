Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161980AbaKNU7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:59:36 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60914 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161200AbaKNU7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:59:35 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
Date: Fri, 14 Nov 2014 12:59:31 -0800
Message-ID: <1541270.g199T8YFIC@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-39-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Friday, November 14, 2014 08:38:19 PM Pali Rohár wrote:
> This patch series fix detection and identifying trackstick on machines with
> ALPS devices. Last patch split trackstick and bare PS/2 mouse packets
> between dev2 and dev3 input devices which make sure that driver will send
> only trackstick data to trackstick input device.
> 

Thank you for splitting the change, unfortunately it is now quite big
to apply to 3.18. Any chance you could try implementing what I suggested
in http://www.spinics.net/lists/linux-input/msg34029.html
and then we can do the more comprehensive solution in 3.19.

Thanks.

-- 
Dmitry
