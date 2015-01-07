Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbbAGCT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:19:27 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39864 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbbAGCTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:19:23 -0500
Date: Tue, 6 Jan 2015 18:21:55 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 percpu/for-3.20] percpu_ref: implement
 percpu_ref_is_dying()
Message-ID: <20150107022155.GD2433@kmo-pixel>
References: <20150106152347.GD3077@htj.dyndns.org>
 <20150106152459.GE3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106152459.GE3077@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:24:59AM -0500, Tejun Heo wrote:
> Implement percpu_ref_is_dying() which tests whether the ref is dying
> or dead.  This is useful to determine the current state when a
> percpu_ref is used as a cyclic on/off switch via kill and reinit.

Acked-by: Kent Overstreet <kmo@daterainc.com>
