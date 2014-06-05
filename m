Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaFEL4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:56:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55026 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaFEL43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:56:29 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tools: ffs-test: convert to new descriptor format fixing compilation error
In-Reply-To: <008101cf80b0$caf88dc0$60e9a940$%opasiak@samsung.com>
Organization: http://mina86.com/
References: <1401954206-8491-1-git-send-email-mina86@mina86.com> <1401954206-8491-2-git-send-email-mina86@mina86.com> <008101cf80b0$caf88dc0$60e9a940$%opasiak@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140605:linux-usb@vger.kernel.org::na1mh9XN1XkvE14F:0000000000000000000000000000000000000D+p
X-Hashcash: 1:20:140605:linux-kernel@vger.kernel.org::vJKT0JEqQ3JMq7Wb:0000000000000000000000000000000002090
X-Hashcash: 1:20:140605:k.opasiak@samsung.com::TdRfl/K6QdI9IOIk:00000000000000000000000000000000000000003two
X-Hashcash: 1:20:140605:k.opasiak@samsung.com::jEr6uTsstiB3FOf3:00000000000000000000000000000000000000004czu
X-Hashcash: 1:20:140605:balbi@ti.com::fqqq7nJjS9IJBcYW:00000EYzD
Date: Thu, 05 Jun 2014 13:56:24 +0200
Message-ID: <xa1tvbsfmuxj.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05 2014, Krzysztof Opasiak <k.opasiak@samsung.com> wrote:
> I would suggest adding a suitable structure as you described in
> previous discussion[1]. Writing first 3 fields in each userspace
> program doesn't look quite good. Using:
>
> #ifndef USE_LEGACY_DESC_HEAD
> struct {
> 	struct usb_functionfs_desc_head2 header;
> 	__le32 fs_count
> 	(... and rest according to flags ...)
> } __attribute__((packed)) header;
> #else ...
>
> Would be shorter, more flexible and user friendly. Moreover it gives
> less places for mistake (writing fields in wrong order).

For ffs-test with USE_LEGACY_DESC_HEAD support it would be longer.
Compare:

----------- >8 ---------------------------------------------------------
static const struct {
	struct {
		__le32 magic;
		__le32 length;
#ifndef USE_LEGACY_DESC_HEAD
		__le32 flags;
#endif
		__le32 fs_count;
		__le32 hs_count;
	} __attribute__((packed)) header;
	/* … */
} __attribute__((packed)) descriptors = {
	.header = {
#ifdef USE_LEGACY_DESC_HEAD
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
#else
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
				     FUNCTIONFS_HAS_HS_DESC),
#endif
		.length = cpu_to_le32(sizeof descriptors),
		.fs_count = 3,
		.hs_count = 3,
	},
	/* … */
};
----------- >8 ---------------------------------------------------------

with

----------- >8 ---------------------------------------------------------
static const struct {
#ifdef USE_LEGACY_DESC_HEAD
	struct usb_functionfs_descs_head header;
#else
	struct usb_functionfs_descs_head2 header;
	__le32 fs_count;
	__le32 hs_count;
#endif
	/* … */
} __attribute__((packed)) descriptors = {
#ifndef USE_LEGACY_DESC_HEAD
	.fs_count = 3,
	.hs_count = 3,
	.header = {
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
				     FUNCTIONFS_HAS_HS_DESC),
#else
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
		.fs_count = 3,
		.hs_count = 3,
#endif
		.length = cpu_to_le32(sizeof descriptors),
	},
	/* … */
};
----------- >8 ---------------------------------------------------------

or with

----------- >8 ---------------------------------------------------------
static const struct {
#ifdef USE_LEGACY_DESC_HEAD
	struct usb_functionfs_descs_head header;
#else
	struct {
		struct usb_functionfs_descs_head2 header;
		__le32 fs_count;
		__le32 hs_count;
	} header;
#endif
	/* … */
} __attribute__((packed)) descriptors = {
	.header = {
#ifdef USE_LEGACY_DESC_HEAD
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
		.length = cpu_to_le32(sizeof descriptors),
#else
		.header = {
			.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
			.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
					     FUNCTIONFS_HAS_HS_DESC),
			.length = cpu_to_le32(sizeof descriptors),
		},
#endif
		.fs_count = 3,
		.hs_count = 3,
	},
	/* … */
};
----------- >8 ---------------------------------------------------------

The second one uses an unreadable hack to match length of the first one
and the third one is two lines longer.  On top of that, the second and
third produce different structures, use more complicated preprocessing
directives, and repeat value of fs_count and hs_count twice.

Without legacy support, it would indeed be shorter (by two lines), but
would lead to awkward structures:

----------- >8 ---------------------------------------------------------
struct {
	struct usb_functionfs_descs_head2 header;
	/* Why aren't the two below fields inside of a header? */
	__le32 fs_count;  
	__le32 hs_count;
};

struct {
	struct {
		/* Why is there a header.header field? */
		struct usb_functionfs_descs_head2 header;
		__le32 fs_count;  
		__le32 hs_count;
	};
};
----------- >8 ---------------------------------------------------------

And I don't see how it would be more flexible.  If anything, it would be
less.

I understand, and share, your sentiment, but I don't think adding 
usb_functionfs_descs_head2 structure with magic, flags and length would
improve the situation.

Something I thought about shortly was:

----------- >8 ---------------------------------------------------------
#define USB_FFS_DESCS_HEAD(_flags) struct {				\
		__le32 magic, length, flags;				\
		__le32 data[!!(_flags & FUNCTIONFS_HAS_FS_DESC) +	\
			    !!(_flags & FUNCTIONFS_HAS_HS_DESC) +	\
			    !!(_flags & FUNCTIONFS_HAS_SS_DESC)];	\
	} __attribute__((packed))

#define USB_FFS_DESCS_HEAD_INIT(_flags, length, ...) {			\
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),	\
		.flags = cpu_to_le32(flags),				\
		.langth = cpu_to_le32(length),				\
		.data = { __VA_ARGS__ }					\
	}

static const struct {
	USB_FFS_DESCS_HEAD(FUNCTIONFS_HAS_FS_DESC | FUNCTIONFS_HAS_HS_DESC),
	/* … */
} __attribute__((packed)) descriptors = {
	USB_FFS_DESCS_HEAD_INIT(FUNCTIONFS_HAS_FS_DESC | FUNCTIONFS_HAS_HS_DESC,
				sizeof(descriptors), 3, 3),
	/* … */
};
----------- >8 ---------------------------------------------------------

But whether this is nicer is arguable as well.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
