Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3I0Ufh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:35:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3I0Ufe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:35:34 -0400
Message-ID: <5245EBE5.6030004@zytor.com>
Date: Fri, 27 Sep 2013 13:34:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
References: <20130925001344.GA13554@redhat.com> <5245E7B1.2000408@zytor.com> <20130927201951.GA22836@redhat.com>
In-Reply-To: <20130927201951.GA22836@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 01:19 PM, Dave Jones wrote:
> 
> Either that or 'bios'.  The question I have is, of those marked 'bios', does =pci
> work too ?  If we knew that was true, I'd probably say yes.
> 

Who knows.  reboot=bios used to only work on 32 bits until very recently.

	-hpa


