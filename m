Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaDAN3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:29:10 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39047 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaDAN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140328102220.GU30768@sirena.org.uk>
References: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
	<1395984022-8284-3-git-send-email-tushar.behera@linaro.org>
	<20140328102220.GU30768@sirena.org.uk>
Date: Tue, 1 Apr 2014 18:59:04 +0530
Message-ID: <CAHbNUh0dwBWfT=AAYP_W2yx2xkbnjbhOBF_PSKrLdv1VaUv9Sw@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: core: Add reg_ignore_unused to keep boot
 time regulators enabled
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2014 15:52, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Mar 28, 2014 at 10:50:22AM +0530, Tushar Behera wrote:
>> Keep all regulators already enabled by bootloader on, even if no
>> driver has claimed them. This is useful for debug and development, but
>> should not be needed on a platform with proper driver support.
>
> That's already the default on non-DT systems so I'd expect that if we
> were doing this the code would be joined up with the code for that.  I'm
> not sure this is a terribly good idea though - we already display a
> message just before we power off the regulator and having an option like
> this feels like it's going to encourage people to write bad DTs and tell
> people to add this to their command line.

I agree with your point that it may lead developers to write bad DTs,
but it becomes quite helpful while debugging issues.

-- 
Tushar Behera
