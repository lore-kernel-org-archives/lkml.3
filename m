Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3LCFyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:54:46 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:64851 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3LCFyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <001a01ceefb2$d21c4bd0$7654e370$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<001a01ceefb2$d21c4bd0$7654e370$%han@samsung.com>
Date: Tue, 3 Dec 2013 11:24:42 +0530
X-Google-Sender-Auth: ODbFrtVH49OlB_D12UJ0DImK95U
Message-ID: <CAOh2x=kKyket469zicV0KgYpeF7EMHSY5iuNSHvnf1b1QSgGjw@mail.gmail.com>
Subject: Re: [PATCH 05/39] cpufreq: nforce2: remove DEFINE_PCI_DEVICE_TABLE macro
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 4:34 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/cpufreq/cpufreq-nforce2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
> index a05b876..353ccfa 100644
> --- a/drivers/cpufreq/cpufreq-nforce2.c
> +++ b/drivers/cpufreq/cpufreq-nforce2.c
> @@ -379,7 +379,7 @@ static struct cpufreq_driver nforce2_driver = {
>  };
>
>  #ifdef MODULE
> -static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
> +static const struct pci_device_id nforce2_ids[] = {
>         { PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2 },
>         {}
>  };

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
