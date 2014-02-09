Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBIUyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:54:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaBIUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:54:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Sun, 9 Feb 2014 21:53:51 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <55674412.rAimUmdW3X@wuerfel> <52F4C51A.90002@xs4all.nl>
In-Reply-To: <52F4C51A.90002@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402092153.51781.arnd@arndb.de>
X-Provags-ID: V02:K0:Jb/MlDOQrYCGG+dPXFkFIsXTeSUslU7sizp8rN34LhU
 0BjB07e1evamrAsJX68WTgiTp+s6HW+T4RcKUo+NDY9Jm1AmFt
 iUjAmFrPeW0eX4vd5rcMaPPq7LqPtoibhLnFnRMvMm4LjKA3b6
 LQKzJWpes6H6GXIw0ugQ0Bt2bkYjEaLBXmg6w44kgIW2PxbnSQ
 FryTZt0Rszy7B1KXTKoqNTOO4Q3CmbcBnDdnC2vBL4zMjXyOCy
 VIh4OgjmRhGVT3CEUUVSBSkGE643B0y8F8/L4HeFK5XPGttFJf
 f0gFGyuaIMJx16v/OsI1+nbAIgBx83a/XN38u2nGL+5gL9XXYd
 SNZcUxxY41rC0LGFoC14=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014, Hans Verkuil wrote:
> OK, let's try again. This patch is getting bigger and bigger, but it is always
> nice to know that your ISA card that almost no one else in the world has is really,
> really working well. :-)
> 
> Regards,
> 
>         Hans
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good,

Acked-by: Arnd Bergmann <arnd@arndb.de>
