Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3JFDzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:55:41 -0400
Received: from outbound-ss-742.hostmonster.com ([74.220.223.97]:39296 "HELO
	outbound-ss-742.hostmonster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753931Ab3JFDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:55:40 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2013 23:55:40 EDT
Message-ID: <1381031338.10109.2.camel@Wailaba2>
Subject: Re: [alsa-devel] [RFC/RFT v2 0/4] ALSA: hda - hdmi: ATI/AMD
 multi-channel and HBR support
From: Olivier Langlois <olivier@trillion01.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org,
        Peter =?ISO-8859-1?Q?Fr=FChberger?= <fritsch@xbmc.org>
Date: Sat, 05 Oct 2013 23:48:58 -0400
In-Reply-To: <524F51C6.7050203@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
	 <1380870371.875.14.camel@Wailaba2> <524F51C6.7050203@iki.fi>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.179.63.169 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > Rear left and rear right channels are flipped.
> 
> Thanks for testing.
> 
> That seems a bit strange, I would've expected everything to be flipped
> if there was a bug there.
> 
Anssi, you were right to be suspicious. The bug was in my wiring.
> 
> >>
> >>   o Contents of /proc/asound/cardX/eld#0. I'd like to see the contents
> >>     both with radeon and with the proprietary fglrx driver in use
> >>
> > With fglrx 13.10 Beta 2:
> > 
> > lano1106@whippet2 /proc/asound/card0 $ cat codec#0 
> 
> Note I said eld#0, not codec#0 :)
> 
> Though I guess the correct filename is actually eld#0.0.
> 
> [...]
> 
My mistake.

Here is the good content:

monitor_present		1
eld_valid		1
monitor_name		
connection_type		HDMI
eld_version		[0x2] CEA-861D or below
edid_version		[0x0] no CEA EDID Timing Extension block present
manufacture_id		0x0
product_id		0x0
port_id			0x0
support_hdcp		0
support_ai		0
audio_sync_delay	0
speakers		[0x4f] FL/FR LFE FC RL/RR RLC/RRC
sad_count		7
sad0_coding_type	[0x1] LPCM
sad0_channels		8
sad0_rates		[0x1ee0] 32000 44100 48000 88200 96000 176400 192000
sad0_bits		[0xe0000] 16 20 24
sad1_coding_type	[0x2] AC-3
sad1_channels		6
sad1_rates		[0xe0] 32000 44100 48000
sad1_max_bitrate	640000
sad2_coding_type	[0x7] DTS
sad2_channels		7
sad2_rates		[0x6c0] 44100 48000 88200 96000
sad2_max_bitrate	1536000
sad3_coding_type	[0xa] E-AC-3/DD+ (Dolby Digital Plus)
sad3_channels		8
sad3_rates		[0xc0] 44100 48000
sad4_coding_type	[0xb] DTS-HD
sad4_channels		8
sad4_rates		[0x1ec0] 44100 48000 88200 96000 176400 192000
sad5_coding_type	[0xc] MLP (Dolby TrueHD)
sad5_channels		8
sad5_rates		[0x1ec0] 44100 48000 88200 96000 176400 192000
sad6_coding_type	[0xe] WMAPro
sad6_channels		8
sad6_rates		[0x6e0] 32000 44100 48000 88200 96000
sad6_profile		3


