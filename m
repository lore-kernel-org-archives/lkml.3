Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3AVDWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:22:54 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:59117 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3AVDWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:22:53 -0500
Message-ID: <50FE05FF.508@xs4all.nl>
Date: Tue, 22 Jan 2013 04:22:39 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com
CC: Jacob Shin <jacob.shin@amd.com>, Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450.GA24792@jshin-Toonie> <1358807712.2812.2.camel@Greyghost-ubuntu>
In-Reply-To: <1358807712.2812.2.camel@Greyghost-ubuntu>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-21 23:35, Suravee Suthikulpanit wrote:
> Would you please try the following and check the output value
> on your system?
> 
> # setpci -s 00:00.02 F0.w=90
> # setpci -s 00:00.02 F4.w

# setpci -s 00:00.02 F0.w=90
# setpci -s 00:00.02 F4.w
0050
#


Udo

