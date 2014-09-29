Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaI2CpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 22:45:10 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54845 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaI2CpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 22:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <54270032.5010204@zonque.org>
References: <1411622662-16581-1-git-send-email-mranostay@gmail.com>
	<1411622662-16581-2-git-send-email-mranostay@gmail.com>
	<54270032.5010204@zonque.org>
Date: Sun, 28 Sep 2014 19:45:07 -0700
Message-ID: <CAKzfze9NiOc8_RcOV7RwURKciVCUWY6XyhBk_CsPxTj4r7-q6Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cap11xx: make driver generic for variant support
From: Matt Ranostay <mranostay@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Kumar Gala <galak@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 11:21 AM, Daniel Mack <daniel@zonque.org> wrote:
> On 09/25/2014 07:24 AM, Matt Ranostay wrote:
>> cap1106 driver can support much more one device make the driver
>> generic for support of similiar parts.
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>  .../devicetree/bindings/input/cap1106.txt          |  53 ----
>>  .../devicetree/bindings/input/cap11xx.txt          |  54 ++++
>>  drivers/input/keyboard/Kconfig                     |   8 +-
>>  drivers/input/keyboard/Makefile                    |   2 +-
>>  drivers/input/keyboard/cap1106.c                   | 341 ---------------------
>>  drivers/input/keyboard/cap11xx.c                   | 340 ++++++++++++++++++++
>>  6 files changed, 399 insertions(+), 399 deletions(-)
>
> As I've said, such a patch is really a whole lot more readable if you
> use the -M switch for git format-patch to detect renames.
>

TIL I learned of new git format-patch option. Will resubmit v4.

> Other than that, the series now looks good to me. I can't test it,
> however, as I don't have access to the hardware anymore.
>

Yeah I can't confirm it works on cap1106 but there is no reason it
wouldn't work.
Cap1188 works as expected.

Thanks,

Matt

>   Reviewed-by: Daniel Mack <daniel@zonque.org>
>
>
>
> Thanks,
> Daniel
>
