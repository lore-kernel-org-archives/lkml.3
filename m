Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3IEPpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:45:38 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37088 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3IEPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAFrcx1=V7zRuK767RHCXbu99Mtf+VZrmv7_4mOn7Kb6B8cd2sQ@mail.gmail.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
	<1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
	<20130905124508.GE9696@mudshark.cambridge.arm.com>
	<CAORVsuW-1koTMaSMgjagBz1aJ0AtvVRiM5gs3kwO2Fuvk+DhwQ@mail.gmail.com>
	<CAKv+Gu8u4PLVfng8ru4RFwA-+Ky0vYEP3V2=vecqndo5Z0sTJg@mail.gmail.com>
	<20130905131910.GB22351@mudshark.cambridge.arm.com>
	<CAFrcx1koLAnNRBtpAhOoTP0SC-wWknY7ipUmcvnjxKqwDOUmag@mail.gmail.com>
	<CAFrcx1=V7zRuK767RHCXbu99Mtf+VZrmv7_4mOn7Kb6B8cd2sQ@mail.gmail.com>
Date: Thu, 5 Sep 2013 17:45:35 +0200
Message-ID: <CAKv+Gu9KYonToLdhnVeMpfm41zYydo9EqxM+a-6iVGQNgZz5hQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@newoldbits.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2013 17:29, Jean Pihet <jean.pihet@linaro.org> wrote:

[...]

> The segfault is caused by libunwind. With the latest version [1],
> dwarf unwinding works fine.
> Investigation on-going, more to come!
>
> [1] git://git.sv.gnu.org/libunwind.git
>

I managed to get it to work by upgrading to Ubuntu Saucy's libunwind8
on a Ubuntu Raring system (Calxeda Highbank)

FWIW, for the series

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> # on
ARM/Highbank/UbuntuSaucy

-- 
Ard.
