Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3ARPIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:08:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3ARPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:08:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 74/76] ARC: [Review] Multi-platform image #7: SMP common code to use callbacks
Date: Fri, 18 Jan 2013 15:08:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358512827-7694-1-git-send-email-vgupta@synopsys.com> <1358512827-7694-3-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358512827-7694-3-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181508.05723.arnd@arndb.de>
X-Provags-ID: V02:K0:hHLStsDqXjkZBT28xYHj+cjLccAlK3MUSzQ1CghxBTH
 rZHbZXBWz5rs+2m2WY5Oa0+P9tH3puk3YydrrmtcvbK5d8KKDc
 cTjPtZ8DEfGqJg0uFA6EQfXutXq0EXGwzJrbBaotXhb8iS5dhD
 axSD49TEr98VI2o5RYDZMhmNMNB2Thvj4gOOtUJwfJfzf8JSG/
 20wVxrImoBrBfm2A6Dq3fkwu5+CVDrq0h/tpapJUoafUeSZSK2
 uY3uftU9bk6YwjP6naHY7IutW++Vst1nHnUj2SoirLYtS3NNXf
 jl7d4ApE9PLx3F6Dbw4WYK+kmG+sSbuA7SCqhywBGZexaYFaoX
 SEHSkFOJEViCHlwqraYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> This again is for switch from singleton platform SMP API to
> multi-platform paradigm
> 
> Platform code is not yet setup to populate the callbacks, that happens
> in next commit
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
