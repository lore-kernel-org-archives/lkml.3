Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3DWQyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:54:50 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.98]:57145 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab3DWQyt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:54:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1366735652!8017975!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 23 Apr 2013 11:46:46 -0500
Subject: RE: [PATCH 15/21] staging: comedi/dawboard2000: use mdelay for
 large delays
Thread-Topic: [PATCH 15/21] staging: comedi/dawboard2000: use mdelay for
 large delays
Thread-Index: Ac5AQSpf/m9pJFMMQAeNQmGjW4TrvwAAMoZw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021D422D5F61@AUSP01VMBX24.collaborationhost.net>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-16-git-send-email-arnd@arndb.de>
In-Reply-To: <1366734653-488286-16-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 23, 2013 9:31 AM, Arnd Bergmann wrote:
> Subject: [PATCH 15/21] staging: comedi/dawboard2000: use mdelay for large delays

Nit.. Typo in subject.

> On ARM, it is not legal to pass values larger than 2ms into udelay(),
> and mdelay() must be used instead, to avoid this build error:
>
> ERROR: "__bad_udelay" [drivers/staging/comedi/drivers/daqboard2000.ko]
> undefined!
>
> On a related note, any use of mdelay() or large udelay() numbers should
> be carefully reviewed, and replaced with msleep() or a different
> implementation that does not rely on delaying the work.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks,
Hartley
