Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3HENGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:06:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49865 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3HENGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:06:16 -0400
Message-ID: <51FFA324.1090901@zytor.com>
Date: Mon, 05 Aug 2013 06:05:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] urgent fix
References: <20130729080836.GD2515@console-pimps.org> <20130730185212.GA21687@gmail.com> <20130805130242.GU2515@console-pimps.org>
In-Reply-To: <20130805130242.GU2515@console-pimps.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 06:02 AM, Matt Fleming wrote:
> On Tue, 30 Jul, at 08:52:12PM, Ingo Molnar wrote:
>> Pulled into tip:x86/urgent, thanks Matt!
> 
> Thanks Ingo.
> 
> Any chance we can get this to Linus for -rc5? The ARM EFI boot stub
> patches depend on the bug fix in this pull request.
> 

Yes, we should push the urgent queue to Linus.

	-hpa

