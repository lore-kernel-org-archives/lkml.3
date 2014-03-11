Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaCKOp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:45:56 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52031 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaCKOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:45:55 -0400
Message-ID: <531F2198.9090602@mev.co.uk>
Date: Tue, 11 Mar 2014 14:45:44 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Conrad Meyer <cemeyer@uw.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH 2/2] Staging: comedi: Validate early to flatten code
References: <1394382281-22712-1-git-send-email-cse.cem@gmail.com> <1394382281-22712-2-git-send-email-cse.cem@gmail.com>
In-Reply-To: <1394382281-22712-2-git-send-email-cse.cem@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-09 16:24, Conrad Meyer wrote:
> Take advantage of -EINVAL returns to flatten code structure and
> hopefully reduce the number of 80+ character lines.
>
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
