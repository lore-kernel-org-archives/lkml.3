Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3LQPG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:06:59 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62894 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3LQPG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:06:57 -0500
MIME-Version: 1.0
Date: Tue, 17 Dec 2013 15:06:57 +0000
X-Google-Sender-Auth: Rt3m4jHGJnkI-Wbg7HpqYjZ6h30
Message-ID: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
Subject: Lindent formatting issues
From: Laszlo Papp <lpapp@kde.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

./scripts/Lindent seems to be working OK, but there are a few minor
issues like this:

static struct i2c_driver max6651_driver = {
        .driver = {
-               .name = "gpio-max6651",
-               .owner = THIS_MODULE,
-       },
+                  .name = "gpio-max6651",
+                  .owner = THIS_MODULE,
+                  },

Is there an option or something to mkae it work automatically? I am
referring to the "}," line which should not have changed.

Cheers,
Laszlo

PS.: I know it is an "indent" related question, but I do not see an
option for available this, and the project seems to be umaintained.
