Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3AOCHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:07:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40718 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736Ab3AOCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:07:14 -0500
Date: Tue, 15 Jan 2013 11:07:02 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] extcon-arizona updates
Message-ID: <20130115020701.GA5701@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <50EF71C3.6060009@samsung.com>
 <20130114075923.GD4833@opensource.wolfsonmicro.com>
 <20130114142921.GB20384@kroah.com>
 <50F481F5.9070804@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F481F5.9070804@samsung.com>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 07:08:53AM +0900, Chanwoo Choi wrote:

> OK, I will send pull request to GregKH for extcon immediately.

Thanks.  Like I say if you're doing this it's probably also worth asking
to get the tree in -next, the build coverage (especially from Fenguang's
awesome build farm!) and merge test coverage are both worth it.
