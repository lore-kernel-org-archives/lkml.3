Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaGHWiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:38:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45241 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaGHWip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:38:45 -0400
Message-ID: <53BC72D8.4090705@zytor.com>
Date: Tue, 08 Jul 2014 15:38:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stuart Hayes <stuart.w.hayes@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com, bp@suse.de
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com>
In-Reply-To: <53BC7210.1000305@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 03:34 PM, Stuart Hayes wrote:
> 
> I haven't received any responses... is there a problem with the patch?  Also CCing a couple people.
> 

I was on vacation last week and am still catching up.

It would also help if you describe the real-world scenario that made you
trip over this.

	-hpa

