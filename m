Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967918Ab3DSGXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:23:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46858 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3DSGXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:23:11 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130419061146.GA16775@kroah.com>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419055813.GA16443@kroah.com> <bb2db2a1-835f-47d0-830d-0dd3785343a9@email.android.com> <20130419061146.GA16775@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 18 Apr 2013 23:17:53 -0700
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matt@console-pimps.org, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, mingo@kernel.org, tglx@linutronix.de
Message-ID: <d1d3e008-21e3-4050-9e05-89d95c34b8ef@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nope, just a vehicle for experiments.

Greg KH <gregkh@linuxfoundation.org> wrote:

>On Thu, Apr 18, 2013 at 11:00:27PM -0700, H. Peter Anvin wrote:
>> The only real use for command line options is to be able to get users
>> to test something during troubleshooting.
>
>Ok, but the option shouldn't be used to "solve" the problem.
>
>greg k-h

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
