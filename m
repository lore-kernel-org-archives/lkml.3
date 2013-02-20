Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247Ab3BTMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:16:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935029Ab3BTMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:16:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dong Aisheng <dong.aisheng@linaro.org>
Subject: Re: Re[8]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 12:16:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201114.49304.arnd@arndb.de> <CAP1dx+x_+jXTdWM2oH7JTBSQfy97hHkJVTmu8=3X_6iEiuAb4A@mail.gmail.com>
In-Reply-To: <CAP1dx+x_+jXTdWM2oH7JTBSQfy97hHkJVTmu8=3X_6iEiuAb4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201216.10721.arnd@arndb.de>
X-Provags-ID: V02:K0:YaFdlqPdNvbIwxQY2l5PbxApG49FQ6cp0EG0qc9kXdM
 1NniOBP7hhhRYGVRbSHe8C2fUMrTlSnYp6RU6sARo3gzAV9ypo
 hZ5IEIlS4ymeyjd8eP+Eacx376R6WQYyZLVXIxN/W13rJ6bOSQ
 8Ci70vEsPEhu51E1FnZ+o5zzyrvQWQHZpIrVOb0N0YN4fHQfVI
 iollb5X0IZ5BRE1qR35WU0GMnWroQCcydgpXEGfeAfYIM+BZV2
 kZp5SVCGAJBrsDFDcAxioYL8YcmQgYKNc8Sx8aQJjVeI2cquNo
 uP6RoAEzMfqaiXqOLOuqyqQMpm27rmelF2pOr71M9cDuLiWB7N
 aMc1Zn1+tENA3/PhiNMs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Dong Aisheng wrote:
> But one question i wonder is that it may be hard to know how many poteintial
> non-dt platforms may use syscon.

Yes, good point. Of course we want as many platforms as possible to
use syscon, just like we want them to use DT, because both things
are generally useful concepts, but they are not necessarily tied
together.

	Arnd
