Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3AWJgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:36:01 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45714 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3AWJf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:35:59 -0500
MIME-Version: 1.0
In-Reply-To: <1358203840.10402.3.camel@lorien2>
References: <1358203840.10402.3.camel@lorien2>
Date: Wed, 23 Jan 2013 09:35:57 +0000
Message-ID: <CAHR064jGOp7tZL4ZAmOLp5G3cWXwjBtsZVH=sL1xsxOGMoMBOg@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL] asus-wmi: Fix unused function build warning
From: Corentin Chary <corentin.chary@gmail.com>
To: shuah.khan@hp.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:50 PM, Shuah Khan <shuah.khan@hp.com> wrote:
> Fix the following build warning
>
> CC [M]  drivers/platform/x86/asus-wmi.o
> drivers/platform/x86/asus-wmi.c:1356:13: warning: ‘do_nothing’ defined but not used [-Wunused-function]
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  drivers/platform/x86/asus-wmi.c |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index e41eae3..c11b242 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1353,11 +1353,6 @@ static int is_display_toggle(int code)
>         return 0;
>  }
>
> -static void do_nothing(void)
> -{
> -       return;
> -}
> -
>  static void asus_wmi_notify(u32 value, void *context)
>  {
>         struct asus_wmi *asus = context;
> --
> 1.7.9.5
>
>
>

Acked-by: Corentin Chary <corentin.chary@gmail.com>



--
Corentin Chary
http://xf.iksaif.net
