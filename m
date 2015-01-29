Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbbA2LVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:21:52 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:34989 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbbA2LVu (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 29 Jan 2015 06:21:50 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 06:21:50 EST
Message-ID: <1422530501.4604.34.camel@stgolabs.net>
Subject: Re: [PATCH v5] media: au0828 - convert to use videobuf2
From: Davidlohr Bueso <dave@stgolabs.net>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 03:21:41 -0800
In-Reply-To: <54CA166B.6000101@cisco.com>
References: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>
	 <54C96D4C.6070200@osg.samsung.com> <1422530027.4604.32.camel@stgolabs.net>
	 <54CA166B.6000101@cisco.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 12:15 +0100, Hans Verkuil wrote:
> You can't split this up, it's one of those changes that is all or
> nothing.

Fair enough. With changes that large, it should be mentioned, though.
Thanks.

