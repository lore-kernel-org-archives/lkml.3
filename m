Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaBCNPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:15:07 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:59389 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBCNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:15:06 -0500
MIME-Version: 1.0
In-Reply-To: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
References: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
Date: Mon, 3 Feb 2014 18:45:04 +0530
Message-ID: <CAKDJKT65t+dkjEmjL_sKbmVZYiu+bGyT_7Kft1H22KwMh22u7Q@mail.gmail.com>
Subject: Re: [PATCH V4 0/2] devm_* API operation for fixed regulator
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        gregkh@linuxfoundation.org,
        =?UTF-8?B?4KSu4KSo4KS/4KS3IOCkrOCkpuCksOCkluClhw==?= 
	<badarkhe.manish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,



On Wed, Jan 29, 2014 at 8:27 PM, Manish Badarkhe
<badarkhe.manish@gmail.com> wrote:
> Use devm_* API operations for fixed regulator driver so that
> driver core will manage resources.
>
> Also, introduce a new API "devm_kstrdup" and used it in fixed
> regulator driver to manage resources.
>
> Changes since V3:
>  1. Update "devm_kstrdup" function to remove "size" argument.
>     Also,used "devm_kmalloc" instead of "devm_kzalloc".
>
> Changes since V2:
>  1. Update driver to use new API "devm_kstrdup" instead of
>     "kstrdup".
>  2. Added a seperate patch to introduce new API "devm_kstrdup"
>
> Changes since V1:
>  1. Updated driver to use "devm_kzalloc" instead of "kstrdup".
>  2. Updated commit message.
>
> Manish Badarkhe (2):
>   devres: introduce API "devm_kstrdup"
>   regulator: fixed: update to devm_* API
>
>  drivers/base/devres.c     |   26 ++++++++++++++++++++++++++
>  drivers/regulator/fixed.c |   42 ++++++++++++------------------------------
>  include/linux/device.h    |    1 +
>  3 files changed, 39 insertions(+), 30 deletions(-)

Are there any review comments on this series?

Regards,
Manish Badarkhe
