Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab3DGLhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:37:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38690 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab3DGLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:37:23 -0400
X-Spam-Score: -100.8
Message-ID: <51615A56.40209@asianux.com>
Date: Sun, 07 Apr 2013 19:36:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Base: Regmap: fix warnings, use %zu instead
 of %d for printf format
References: <5160E113.9080502@asianux.com> <8761zybtdg.fsf@nemi.mork.no> <51613B16.3030406@asianux.com> <51613D37.6060901@asianux.com> <20130407113308.GP6597@opensource.wolfsonmicro.com>
In-Reply-To: <20130407113308.GP6597@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月07日 19:33, Mark Brown wrote:
> On Sun, Apr 07, 2013 at 05:32:39PM +0800, Chen Gang wrote:
>> > 
>> >   fix warnings (with EXTRA_CFLAGS=-W):
>> >     format ‘%d’ expects argument of type ‘int’,
>> >     but argument 4 has type ‘size_t’ [-Wformat]
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> I've already applied a patch for this from someone else.


  ok, thanks.

  it seems, I am too late !!

  :-)


-- 
Chen Gang

Asianux Corporation
