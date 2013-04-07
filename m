Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab3DGLgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:36:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38665 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab3DGLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:36:35 -0400
X-Spam-Score: -100.8
Message-ID: <51615A25.2090905@asianux.com>
Date: Sun, 07 Apr 2013 19:36:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Menzel <paulepanter@users.sourceforge.net>
CC: airlied@linux.ie, bskeggs@redhat.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drivers/gpu/drm/nouveau: remove erroneous semicolon
References: <51529E77.2010906@asianux.com> <1365333863.7207.14.camel@mattotaupa>
In-Reply-To: <1365333863.7207.14.camel@mattotaupa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月07日 19:24, Paul Menzel wrote:
> do you know if this cause any problems? Did you find this reading the
> code or by using some tools?

  sorry, I do not know if this can cause any problems.

  for this issue, I did not find it by reading code.

  I find it by using compiler warnings with EXTRA_CFLAGS=-W


  thanks.


  :-)


-- 
Chen Gang

Asianux Corporation
