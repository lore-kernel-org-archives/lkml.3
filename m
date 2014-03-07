Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaCGOGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:06:43 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47055 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaCGOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <5319CF23.6090103@ti.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
	<53145591.4070004@ti.com>
	<CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>
	<53145D42.9080806@ti.com>
	<CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>
	<531465FF.1000201@ti.com>
	<CANq1E4TmACNwyANaUsWufJL1ne4pk4Gv+g4y7b6xeO=Po-SN9g@mail.gmail.com>
	<5319BF40.70305@ti.com>
	<CANq1E4QXWYQE5DWOA7F39oHFd2ZnV5Ny4ykOw1=aJT+B_umy3Q@mail.gmail.com>
	<5319CF23.6090103@ti.com>
Date: Fri, 7 Mar 2014 15:06:40 +0100
Message-ID: <CANq1E4RO5d1AFEdp3Ya5TFNSht87vARtk8nag7qCnKVU54ZYSg@mail.gmail.com>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
From: David Herrmann <dh.herrmann@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi

On Fri, Mar 7, 2014 at 2:52 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 07/03/14 15:05, David Herrmann wrote:
>
>> If you can take these two patches, that's fine. They're not strictly
>> needed by the series and I'd be happy to see them upstream. The other
>> sysfb patches should be merged together, so I don't think there's much
>> gain in applying them through fbdev.
>
> Ok, I've applied them to fbdev tree.

Thanks!

>> The DRM tree is usually merged late, anyway, so I'll see whether we
>> will merge simpledrm through drm-next or not. If not, it'll be 3.16
>> then. If you can get the fbdev merge in early, that should be enough
>> for us to figure it out and provide a conflict-resolution. Btw., do
>> you want the generic sysfb-helper in drivers/video/ or
>> driver/video/fbdev? It's not limited to fbdev, so I'd put it in
>> drivers/video/.
>
> With a quick glance, it doesn't seem to depend on fbdev in any way,
> right? That makes me think drivers/video/.

Right! I will keep them in drivers/video/ then.

Thanks
David
