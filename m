Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBPPD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 10:03:29 -0500
Received: from smtp10a.hushmail.com ([65.39.178.239]:60725 "EHLO
	smtp10.hushmail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752758AbaBPPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 10:03:28 -0500
MIME-Version: 1.0
Date: Sun, 16 Feb 2014 15:03:27 +0000
To: linux-kernel@vger.kernel.org
Subject: System Daemon: The lack of foresight on social and political ramifications in the FOSS world. (systemd)
From: redlynx@hush.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20140216150327.7B00D601FE@smtp.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System Daemon: The lack of foresight on social and political ramifications in the FOSS world.

By Daniel Campbell

""
The lack of foresight on social and political ramifications is epidemic
to most of the FOSS world, as evidenced by the creeping adoption of
systemd. Things are already depending on things that systemd provides,
and is dividing the ecosystem into "systemd" vs "everything else".
Ambitious projects like systemd are damaging to the rich variety that
should be found in the FOSS ecosystem. systemd in particular encourages
embracing vertical integration and rejection of POSIX and UNIX
principles. Its culture is adversarial to anyone who doubts the Great
Image that Lennart and his employer has. If it were a project that was
humble, without an agenda, and did not undergo evangelism, I'd have no
problems with it because choice is something that I value immensely. But
because it *isn't* humble, *has* an agenda, only reached the adoption it
currently has by *lots* of arguing and pushing, and refuses to coexist
with other init systems, I cannot respect it as a legitimate,
non-aggressive, non-intrusive software project. I consider it a toxic
threat to FOSS and refuse to have it on any system I maintain.

Systemd has technical merits (cgroups, socket activation, parellel
execution of daemons, etc), but they fall by the wayside and become
irrelevant to me when it swallows the functionality of multiple projects
that should be separate (see: udev) and tries to be everything to
everyone (splash image, web server, boot time graphs, etc). The social
tactics at work from the systemd team (and verily, other Red Hat
projects like GNOME) are reminiscent of Microsoft through the use of the
"Embrace, Extend, Extinguish" methodology. With their paid developers
and more abundant resources, Red Hat (and arguably other corporations)
can use their developers to push their agendas and, in a sense,
commandeer control of the FOSS world. I will give them no inch on my
systems. I am skeptical of their involvement in the kernel, as well.

It's sad to see Debian giving into peer pressure. I honestly thought
that they would see the agenda miles away and prevent a monoculture. For
people who are technically intelligent, they're seriously lacking any
foresight in their decisions and are completely blind to the social and
political ramifications. Distros will regret depending on such a project
and it will set GNU/Linux development back many years when systemd
becomes a full stack and working without it is made difficult or
impractical (through the use of lock-in tactics). I hope that Gentoo
continues to be a safe haven for choice and the spirit of FOSS. Without
it, I may have to concede and either start building my own distro, or
going to the BSDs.

Just my two cents. Ignore or reply at your discretion.
""

