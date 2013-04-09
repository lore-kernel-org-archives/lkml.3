Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937056Ab3DIO4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:56:45 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44642 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644Ab3DIO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:56:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
	<CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
Date: Tue, 9 Apr 2013 20:26:42 +0530
Message-ID: <CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sedat.dilek@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 19:34, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> I have seen it on reboots.
> How to online/offline from sysfs?

offline a cpu "x" with:

echo 0 > /sys/devices/system/cpu/cpux/online

and online with echo 1 > to same location.
