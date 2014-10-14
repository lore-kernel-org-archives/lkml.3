Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaJNGIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:08:40 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49159 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaJNGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:08:38 -0400
Date: Mon, 13 Oct 2014 23:08:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: alps: Reset mouse before identifying it
Message-ID: <20141014060834.GA8084@dtor-glaptop>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1412329392-5580-2-git-send-email-pali.rohar@gmail.com>
 <542E70CF.40205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <542E70CF.40205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:47:59AM +0200, Hans de Goede wrote:
> Hi,
> 
> Thanks for working on this!
> 
> On 10/03/2014 11:43 AM, Pali Rohár wrote:
> > On some systems after starting computer function alps_identify() does not detect
> > dual ALPS touchpad+trackstick device correctly and detect only touchpad.
> > 
> > Resetting ALPS device before identifiying it fixing this problem and both parts
> > touchpad and trackstick are detected.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > Tested-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Looks good and seems sensible:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>

*sigh* I am not really happy about this, as we making boot longer and longer
for people without ALPS touchpads. It would be better if we only reset the
mouse when we knew we are dealing with ALPS, and even better if we only reset
it when we suspected that we missed trackstick. Any chance of doing this?

Thanks.

-- 
Dmitry
