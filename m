Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaLRVU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:20:27 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:42938 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaLRVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:20:26 -0500
Message-ID: <54934516.5070304@gmail.com>
Date: Fri, 19 Dec 2014 00:20:22 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
References: <20141218135705.GD4918@srcf.ucam.org> <5492DEE7.8010407@gmail.com> <20141218140930.GA6436@srcf.ucam.org> <5492E32E.2030602@gmail.com> <20141218142629.GA6924@srcf.ucam.org> <5492E5F9.2000504@gmail.com> <20141218143623.GA7335@srcf.ucam.org> <5492E753.7090505@gmail.com> <20141218144337.GA7613@srcf.ucam.org> <20141218145054.GA7745@srcf.ucam.org> <20141218200444.GA16724@srcf.ucam.org>
In-Reply-To: <20141218200444.GA16724@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did already. It is not that simple.
https://bugzilla.kernel.org/show_bug.cgi?id=70241#c86

18.12.2014 23:04, Matthew Garrett пишет:
> Ah, http://cgit.freedesktop.org/~jani/drm/log/?h=didl nominally has
> support for doing the right thing here - any chance you can try that
> tree?
>
