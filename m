Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3CZMfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:35:51 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:37353 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab3CZMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:35:50 -0400
Message-ID: <51519623.9040603@monom.org>
Date: Tue, 26 Mar 2013 13:35:47 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] ALSA regression Macbook Air 5, 2: No sound from
 the loudspeaker
References: <51509B84.2050106@monom.org>
In-Reply-To: <51509B84.2050106@monom.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 07:46 PM, Daniel Wagner wrote:
> I experience a regression on my Macbook Air 2012 model with the 3.9-rc
> kernels (v3.9-rc2-284-gaea8b5d) The symptoms are that there is just no
> sound from the loudspeakers. The headphone output works fine.

Oh, there is already a fix in the mainline tree.

   ALSA: hda - Fix missing EAPD/GPIO setup for Cirrus codecs


Haven't tested it yet but looks like then one I was looking for.

cheers,
daniel

