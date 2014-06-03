Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139AbaFCW7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:59:37 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52483 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbaFCW7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:59:36 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:e054:7632:66c1:4b6d]
In-Reply-To: <1401835464-15267-1-git-send-email-bleung@chromium.org>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
Date: Tue, 3 Jun 2014 15:59:36 -0700
Message-ID: <CAOesGMiNhNavOMhBWcH_sEbNHxJ4OM3wjVt4qeK=aZFeVVxT_g@mail.gmail.com>
Subject: Re: [PATCH 0/3] platform/chrome: chromeos_laptop - Add Haswell Chromebooks
From: Olof Johansson <olof@lixom.net>
To: Benson Leung <bleung@chromium.org>
Cc: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 3, 2014 at 3:44 PM, Benson Leung <bleung@chromium.org> wrote:
> This patch series should be applied after Mika Westerberg's patch here:
> https://patchwork.kernel.org/patch/4288591/
>
> It will add support for the cypress touchpads on the HP Chromebook 14,
> Dell Chromebook 11, and Toshiba CB35.
>
> [PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
> [PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 Touch
> [PATCH 3/3] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch

The 3.16 merge window is open, please resend after -rc1 and I'll queue it up.


-Olof
