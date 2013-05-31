Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3EaHwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:52:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40761 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3EaHwf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 31 May 2013 03:52:35 -0400
Message-Id: <51A872F202000078000D9E5B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 31 May 2013 08:52:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "John Stultz" <john.stultz@linaro.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCHv3 0/2] xen: maintain an accurate
 persistent clock in more cases
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
 <51A7E709.9080309@linaro.org>
In-Reply-To: <51A7E709.9080309@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.05.13 at 01:55, John Stultz <john.stultz@linaro.org> wrote:
> The first is probably the easiest, but I do want to make sure that Xen 
> maintainers agree that Xen really needs to be special here compared to 
> every other platform and always enforce the RTC is synced with system time.

Actually, during the v2 discussion I think we made clear that this
is not the goal: Sync-ing of the RTC should be just like native
does it. The only special thing Xen wants is that the hypervisor's
software wall clock wants to be kept up to date when NTP or
whatever else updates Dom0's wall clock.

Jan

