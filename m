Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaFCPgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:36:00 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:58292 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbaFCPf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140603153258.GF31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
	<20140527192923.GC12304@sirena.org.uk>
	<CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
	<20140528173858.GG5099@sirena.org.uk>
	<CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
	<20140603145347.GE31751@sirena.org.uk>
	<CAKohpokRk+PDokcgRdQc+EfRs6t7Uduk8mJinBfANCs36-5_oQ@mail.gmail.com>
	<20140603153258.GF31751@sirena.org.uk>
Date: Tue, 3 Jun 2014 21:05:56 +0530
Message-ID: <CAKohpokVX80K3DEMC7NTVNsxmrNT39t-E1QED2VYycjEmT+ukQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulators: Add definition of regulator_set_voltage_time()
 for !CONFIG_REGULATOR
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 21:02, Mark Brown <broonie@kernel.org> wrote:
> Could you please be more explicit about what you mean by "valid"?

I meant Not NULL..
