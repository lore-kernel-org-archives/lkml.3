Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3ALDHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 22:07:11 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:50949 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3ALDHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 22:07:10 -0500
Message-ID: <1357960044.8515.0.camel@gitbox>
Subject: Re: [PATCH 0/4] arm: vt8500: Add support for Wondermedia
 WM8750/WM8850
From: Tony Prisk <linux@prisktech.co.nz>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Date: Sat, 12 Jan 2013 16:07:24 +1300
In-Reply-To: <20130111215659.GA16521@quad.lixom.net>
References: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
	 <20130111215659.GA16521@quad.lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suggest that you split off the last three (and rebase them to be
> independent), and apply them to a multiplatform branch for vt8500. Then the
> last one is a soc branch that goes on top of the multiplatform branch (i.e. you
> build it on top of multiplatform). That way we can pull in the multiplatform
> changes together with those for other platforms, and then take the wm8{7,8}50
> branch goes in with the other new-soc support from other platforms.
> 
> Does that make sense? I'll be happy to provide more explanation if it doesn't.
> 
> -Olof

I think I understand - pull requests to follow.

Tony P

