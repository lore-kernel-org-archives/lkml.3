Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaBZOsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:48:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:41202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaBZOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:48:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,548,1389772800"; 
   d="scan'208";a="488443186"
Message-ID: <530DFEA4.70601@linux.intel.com>
Date: Wed, 26 Feb 2014 16:48:04 +0200
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, perex <perex@perex.cz>,
        tiwai@suse.de, lgirdwood@gmail.com, broonie <broonie@kernel.org>
Subject: Re: randconfig build error with next-20140226, in sound/soc/intel/sst-baytrail-ipc.c
References: <CA+r1Zhhs8=Vu5uDVoAbyP0JRsRscwhdQ8Dns6cTaABS9Duj8dw@mail.gmail.com>
In-Reply-To: <CA+r1Zhhs8=Vu5uDVoAbyP0JRsRscwhdQ8Dns6cTaABS9Duj8dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 04:36 PM, Jim Davis wrote:
> Building with the attached random configuration file,
>
> sound/soc/intel/sst-baytrail-ipc.c: In function 'sst_byt_get_dsp_position':
> sound/soc/intel/sst-baytrail-ipc.c:743:2: error: implicit declaration
> of function 'memcpy_fromio' [-Werror=implicit-function-declaration]
>    memcpy_fromio(&fw_tstamp,
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [sound/soc/intel/sst-baytrail-ipc.o] Error 1
Thanks, I posted a fix for it earlier today:

http://mailman.alsa-project.org/pipermail/alsa-devel/2014-February/073299.html

Fix is not yet committed so I guess we can have your reported by too?

Reported-by: Jim Davis <jim.epost@gmail.com>

-- 
Jarkko
