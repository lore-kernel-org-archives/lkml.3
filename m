Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaD1HHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:07:31 -0400
Received: from ar-005-i206.relay.mailchannels.net ([162.253.144.88]:19038 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbaD1HGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:06:50 -0400
X-Greylist: delayed 86926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 03:06:50 EDT
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%252bscalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
Message-ID: <535DFDFF.5070106@scalemp.com>
Date: Mon, 28 Apr 2014 10:06:39 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
References: <1398376326-3055-1-git-send-email-oren@scalemp.com> <20140425142248.GL8874@tassilo.jf.intel.com> <535CAA77.4000405@scalemp.com> <20140427183401.GB19657@tassilo.jf.intel.com>
In-Reply-To: <20140427183401.GB19657@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AuthUser: oren+scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
On 04/27/2014 09:34 PM, Andi Kleen wrote:
> Again, what lock protects it?
>
> If you cannot answer that question you likely shouldn't use static.

The only function which touches this variable is vsmp_init() which is an
"_init" function which is guarantee to run by a single cpu - this means, no race.

Thanks,
  Oren
>
> -Andi


