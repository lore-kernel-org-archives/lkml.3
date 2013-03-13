Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3CMLXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:23:08 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:39302 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756424Ab3CMLXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:23:05 -0400
Message-ID: <514060E9.2030208@gaisler.com>
Date: Wed, 13 Mar 2013 12:20:09 +0100
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
References: <20130312153047.dc10eb2392d07af8822e45f1@canb.auug.org.au> <513EF5DD.2010501@gaisler.com> <20130312225719.c70d478eff3e77633d029386@canb.auug.org.au> <20130312161302.GA12317@core.coreip.homeip.net>
In-Reply-To: <20130312161302.GA12317@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 05:13 PM, Dmitry Torokhov wrote:
> On Tue, Mar 12, 2013 at 10:57:19PM +1100, Stephen Rothwell wrote:
>> On Tue, 12 Mar 2013 10:31:09 +0100 Daniel Hellstrom <daniel@gaisler.com> wrote:
>>> APBPS2 driver is missing linux/slab.h required on at least PowerPC. See patch below. How do you want me to proceed?
>> That is up to Dmitry - either a fix up patch (with SoB and commit
>> message) or a replacement patch.
> I fixed up the commit and refreshed the branch.
>
> Thanks.

Thanks,
Daniel
