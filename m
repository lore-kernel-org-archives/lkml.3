Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaBGL7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:59:24 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43150 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbaBGL7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:59:02 -0500
Message-ID: <52F4CA77.5060007@linux.com>
Date: Fri, 07 Feb 2014 12:58:47 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
CC: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3.11 229/233] ALSA: hda - hdmi: introduce patch_nvhdmi()
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com> <1391773652-25214-230-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1391773652-25214-230-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/07/2014 12:47 PM, Luis Henriques wrote:
> 3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.
>  [...]
>  
> +static int patch_nvhdmi(struct hda_codec *codec)
> +{
> +	struct hdmi_spec *spec;
> +	int err;
> +
> +	err = patch_generic_hdmi(codec);
> +	if (err)
> +		return err;
> +
> +	spec = codec->spec;
> +
> +	return 0;
> +}
> [...]

Is it just me or is it that the 'spec' variable has no use?

-- 
Regards,
Levente Kurusa
