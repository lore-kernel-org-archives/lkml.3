Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965957AbaKNPlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:41:49 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61008 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965015AbaKNPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:41:47 -0500
Message-ID: <1415979703.3805.4.camel@maggy.simpson.net>
Subject: Re: [PATCH] rtlwifi: Add more checks for get_btc_status callback
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Murilo Opsfelder =?ISO-8859-1?Q?Ara=FAjo?= <mopsfelder@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Thadeu Cascardo <cascardo@cascardo.eti.br>,
        =?UTF-8?Q?=E8=B0=AD=E6=9D=AD=E6=B3=A2?= <troy_tan@realsil.com.cn>
Date: Fri, 14 Nov 2014 08:41:43 -0700
In-Reply-To: <CA+LKeY6xca=f-qFJoVFaqywRpfHPmMAWDrMmbkUiDf9atA_jVQ@mail.gmail.com>
References: <1414625302-3654-1-git-send-email-mopsfelder@gmail.com>
	 <5451BED0.2060906@lwfinger.net>
	 <1415178975.5402.66.camel@marge.simpson.net>
	 <545A6894.7040506@lwfinger.net> <545B5E19.7030704@gmail.com>
	 <545BFBB4.3040005@gmail.com> <545C0487.1090707@lwfinger.net>
	 <CA+LKeY6xca=f-qFJoVFaqywRpfHPmMAWDrMmbkUiDf9atA_jVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 21:03 -0200, Murilo Opsfelder Araújo wrote:

> Hello, Larry.
> 
> I'd like to let you know that next-20141112 brought my rtl8192se
> device back to life.  I didn't need to build rtlwifi_new to be able to
> connect to my wifi network.  It worked just fine.

Yeah, unsurprisingly, merging those fixed up my lappy as well.

	-Mike

