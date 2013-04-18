Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936685Ab3DRWcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:32:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:5198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936545Ab3DRWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:32:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="320568275"
Date: Fri, 19 Apr 2013 00:31:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Export matrix_keypad_parse_of_params()
Message-ID: <20130418223159.GA8798@zurbaran>
References: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Apr 16, 2013 at 10:50:54AM +0200, Michal Marek wrote:
> Couple of input drivers depend on this symbol:
> 
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/input/matrix-keymap.c | 1 +
>  1 file changed, 1 insertion(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
