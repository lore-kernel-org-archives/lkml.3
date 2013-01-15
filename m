Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3AOMPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:15:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59943 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694Ab3AOMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:15:17 -0500
Date: Tue, 15 Jan 2013 21:15:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: cw00.choi@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon for 3.8-rc4
Message-ID: <20130115121509.GG5701@opensource.wolfsonmicro.com>
References: <50F5067A.2060104@samsung.com>
 <20130115113719.GD1748@kroah.com>
 <CAGTfZH2r9TaNEPQ5am-UFwQd9t_qegxfo3MMOwJxvfctid7=-Q@mail.gmail.com>
 <20130115121356.GA2349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115121356.GA2349@kroah.com>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:13:56AM -0800, Greg KH wrote:

> So can you please go over these patches and ensure that none of them are
> ok for 3.8, and all are fine for 3.9?

I'd not expect any of the arizona patches to be v3.8 material FWIW.
