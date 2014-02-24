Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaBXNID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:08:03 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:54187 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaBXNIB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 24 Feb 2014 08:08:01 -0500
Message-Id: <530B523C020000780011EC49@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 24 Feb 2014 13:07:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Borkmann" <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <davem@davemloft.net>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <ffusco@redhat.com>, <tgraf@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com>
 <5308938A.8070506@redhat.com>
 <530B0AF2020000780011E97B@nat28.tlf.novell.com>
 <530B1D60.8010602@redhat.com>
 <530B32A4020000780011EACB@nat28.tlf.novell.com>
 <530B3102.4050102@redhat.com> <530B3BDB.3010908@zytor.com>
 <530B4C0C020000780011EC0D@nat28.tlf.novell.com> <530B4058.80705@zytor.com>
 <530B429C.2090507@zytor.com>
In-Reply-To: <530B429C.2090507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.02.14 at 14:01, "H. Peter Anvin" <hpa@zytor.com> wrote:
> I never expected that the CRC32 operation would be commutative.  Very 
> fascinating.

Neither did I, which is why I was very surprised for Daniel to say that
things worked with the apparently wrong order.

Jan

