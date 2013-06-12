Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3FLMrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:47:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3FLMrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:47:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 00/11] CPUFreq Kconfig fixes
Date: Wed, 12 Jun 2013 14:46:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
References: <cover.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121447.00139.arnd@arndb.de>
X-Provags-ID: V02:K0:5/TWTRVPjJfPSHAkR1j37BCZyFkg98NYt4WHd8JqzXj
 Xlf1GR+F0ovVjDPHOAjZKKXUoxIOD6VdP7sN9AwxrKQo4vMLAU
 7ZnnzXK8pS/FAv8k0KwWA78WyWOmGhwFHConH2g7jw7gevWdIH
 h+6cV66IWEj8eVAKZHz6rArTELDInT9g1dM6u5eQy1SuEn00dy
 DK2Up+y0ym/0c5E3alNPVyQi6JYJG3olKePiEFayEAPXgz3so1
 gdPodDi/EMlQhGlyao3BvwGgwKP6DXC7phFJklMlNDeqsgWjBj
 X8ro15Cg5ay3uSkrlQayi4BaY9HZy3GthB843Z0YHiC7VNceHQ
 T/cKlYmgtJsNVrUm8z7Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013, Viresh Kumar wrote:
> Recently Arnd sent few fixes where drivers were using APIs from freq_table.c but
> haven't selected CPU_FREQ_TABLE. Based on that, I just crossed checked all the
> places where it should be selected and where it shouldn't be. These are fixes
> around that.
> 
> I have applied these in my cpufreq-kconfig-fixes branch. Will send you a pull
> request separately once I get some Acks (will wait for few days).

Acked-by: Arnd Bergmann <arnd@arndb.de>

I don't see a patch for big.LITTLE in either linux-next or this series. Did you
miss that or has it just not made into linux-next yet?

	Arnd
